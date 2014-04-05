#define IGNORE(...)
#define IDENT(...) __VA_ARGS__

#define CLAUSE_1(...) __VA_ARGS__ IGNORE

/* We ignore the __VA_ARGS__ we get and return a macro that
 * returns whatever is in () following us */
#define CLAUSE_2(...) IDENT


/* All other things are not equal! */
#define IS_EQ_1_1() ,
#define IS_EQ_0_0() ,


#define IS_EQ_(x, y) IS_EQ_##x##_##y()
#define IS_EQ(x, y) IS_EQ_(x, y)


#define PASTE4_(a,b,c,d) a##b##c##d
#define PASTE4(a,b,c,d) PASTE4_(a,b,c,d)

/* IF(expr)(emit-if-expr) */
#define ARG_2(a,b,...) b
#define ARG_3(a,b,c,...) c
#define IF(maybe_comma) ARG_3(maybe_comma,CLAUSE_1,CLAUSE_2,~)
#define IF_EQ(A, B) IF(PASTE4(IS_EQ_,A,_,B)())


int main(void)
{
	return IF_EQ(V, 1)(1)(2) || IF(IS_EQ(0, V))(3)(4);
}
