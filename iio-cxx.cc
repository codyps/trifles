#include <fstream>
#include <filesystem>
#include <iostream>

using std::filesystem::path;
using std::filesystem::create_directory;

void write_1(std::filesystem::path const &p, std::string const &s) {
	std::ofstream f(p.native());
	f.write(s.c_str(), s.size());
}

int main(void) {
	std::ifstream iio_dev("/dev/iio:device0");

	path cfg_d("/sys/kernel/config/iio");
	path dev_d("/sys/bus/iio/devices/iio:device0");

	create_directory(cfg_d / "triggers/hrtimer/inst0");	

	path buffer_enable(dev_d / "buffer/enable");

	write_1(buffer_enable, "0");
	write_1(dev_d / "scan_elements/in_angl_en", "1");
	write_1(dev_d / "scan_elements/in_timestamp_en", "1");
	write_1(dev_d / "trigger/current_trigger", "inst0");
	write_1(buffer_enable, "1");

	struct {
		uint16_t val;
		uint16_t pad[3];
		uint64_t ts;
	} data;

	for (;;) {
		iio_dev.read(reinterpret_cast<char*>(&data), sizeof(data));
		std::cout << data.ts << ": " << data.val << std::endl;
	}
}
