int main()
{
    void *blah = 0;

    __asm__ __volatile__ ("" : : "r" (*blah));
}
