//shstk test program (genr8)
//clang -fsanitize=shadow-call-stack -o shstk shstk.c
/*
genr8eofl@genr8too ~ $ clang-14 -o shstk shstk.c && ./shstk
The compiler does NOT support shadow_call_stack!

genr8eofl@genr8too ~ $ clang-14 -fsanitize=shadow-call-stack -o shstk shstk.c && ./shstk
The compiler DOES support shadow_call_stack!
*/

#include <stdio.h>

//clang macros: https://clang.llvm.org/docs/ShadowCallStack.html#usage
#if defined(__has_feature)
  #if  __has_feature(shadow_call_stack)
  //code that only builds under ShadowCallStack
	int main(void)
	{
	    printf("The compiler DOES support shadow_call_stack!\n");
	}
  #else
  //code that builds when it doesnt
	int main(void)
	{
	    printf("The compiler does NOT support shadow_call_stack!\n");
	}
  #endif
#else
/*
genr8eofl@genr8too ~ $ gcc-11.3.0 -fsanitize=shadow-call-stack -o shstk shstk.c && ./shstk
gcc-11.3.0: error: unrecognized argument to '-fsanitize=' option: 'shadow-call-stack'

genr8eofl@genr8too ~ $ gcc-12.2.0 -fsanitize=shadow-call-stack -o shstk shstk.c
shstk.c: sorry, unimplemented: '-fsanitize=shadow-call-stack' not supported in current platform
*/

// gcc doesnt use these type of macros and doesnt support it anyway
int main(void)
{
    printf("The compiler has no idea what this program is supposed to do !\n");
}
#endif
