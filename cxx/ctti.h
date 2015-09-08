#pragma once

#include "void.h"


template<class, class=void>
struct has_member;

template<class T>
struct has_member<T, void_t<decltype(T::member)>>:true_type
{};
