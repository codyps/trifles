#ifdef __cplusplus
# include <atomic>
using std::atomic_flag;
#else
# include <stdatomic.h>
#endif

struct foo {
    atomic_flag flag;
} bar;

int main(void)
{
    return 0;
}
