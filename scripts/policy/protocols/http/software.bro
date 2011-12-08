##! Software identification and extraction for HTTP traffic.

@load base/frameworks/software

module HTTP;

export {
	redef enum Software::Type += {
		SERVER,
		APPSERVER,
		BROWSER,
	};

	## The pattern of HTTP User-Agents which you would like to ignore.
	const ignored_user_agents = /NO_DEFAULT/ &redef;
}

event http_header(c: connection, is_orig: bool, name: string, value: string) &priority=2
	{
	if ( is_orig )
		{
		if ( name == "USER-AGENT" && ignored_user_agents !in value )
			Software::found([$id=c$id, $banner=value, $host=c$id$orig_h, $sw_type=BROWSER]);
		}
	else
		{
		if ( name == "SERVER" )
			Software::found([$id=c$id, $banner=value, $host=c$id$resp_h, $host_p=c$id$resp_p, $sw_type=SERVER]);
		else if ( name == "X-POWERED-BY" )
			Software::found([$id=c$id, $banner=value, $host=c$id$resp_h, $host_p=c$id$resp_p, $sw_type=APPSERVER]);
		else if ( name == "MICROSOFTSHAREPOINTTEAMSERVICES" )
			{
			value = cat("SharePoint/", value);
			Software::found([$id=c$id, $banner=value, $host=c$id$resp_h, $host_p=c$id$resp_p, $sw_type=APPSERVER]);
			}
		}
	}
