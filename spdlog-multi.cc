#include <spdlog/spdlog.h>
#include <spdlog/sinks/stdout_color_sinks.h>
#include <spdlog/sinks/basic_file_sink.h>

int main() {
	auto combo = std::make_shared<spdlog::logger>("combo", spdlog::sinks_init_list({ 
		std::make_shared<spdlog::sinks::stdout_color_sink_mt>(),
		std::make_shared<spdlog::sinks::basic_file_sink_mt>("out.log")
		})
	);
	spdlog::set_default_logger(combo);

	spdlog::info("Hi");

	spdlog::drop_all();

	return 0;
}
