#include <atomic>

template<typename T>
class AtomicMailbox {
	std::atomic<T*> in_box;
	std::atomic<T*> out_box[2];

	// assert wait free for underlying atomic<>
} mailbox;

void thread_a() {
	// obtain
	T *data = mailbox.in_box.exchange(nullptr /* or some other "empty" */);

	process(data);
	
	size_t which_box = mailbox.out_box[0].load() != nullptr;
	mailbox.out_box[which_box].store(data);
}

void thread_b() {
	// pull from outboxes (must pull from both before pushing in more data to ensure we don't back things up)
	T *data = mailbox.out_box[0].exchange(nullptr);
	T *data2 = mailbox.out_box[1].exchange(nullptr);
	
	// TODO: pick one of `data`/`data2`, keep the other for later
	// TODO: if none of `data` or `data2` is non-null, re-use an old buffer or allocate a new one

	generate(&data);

	T *unprocessed_data = mailbox.in_box.exchange(&data);

	// TODO: keep unprocessed_data for later re-use
}
