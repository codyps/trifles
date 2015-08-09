template<typename completion_type, bool (handle_complete)(args...), bool (do_output)(args...)>
struct one_at_a_time {
	void push(args...) {

	}

	void on_complete(complete_type)
};
