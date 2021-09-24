
#include "Plugin.h"

namespace btest::plugin::Testing_LoadFileExtended
	{
Plugin plugin;
	}

using namespace btest::plugin::Testing_LoadFileExtended;

zeek::plugin::Configuration Plugin::Configure()
	{
	EnableHook(zeek::plugin::HOOK_LOAD_FILE_EXT);

	zeek::plugin::Configuration config;
	config.name = "Testing::LoadFileExtended";
	config.version.major = 0;
	config.version.minor = 1;
	config.version.patch = 4;
	return config;
	}

#include <iostream>

std::pair<int, std::optional<std::string>> Plugin::HookLoadFileExtended(const LoadType type,
                                                                        const std::string& file,
                                                                        const std::string& resolved)
	{
	if ( file == "xxx" )
		{
		printf("HookLoadExtended: file=|%s| resolved=|%s|\n", file.c_str(), resolved.c_str());

		return std::make_pair(1, R"(
			event zeek_init() {
				print "new zeek_init(): script has been replaced";
			}
		)");
		}

	return std::make_pair(-1, std::nullopt);
	}

