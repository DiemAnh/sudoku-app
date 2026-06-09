import 'dart:collection';

class _Node<T> {
	T value;
	_Node<T>? next;
	_Node(this.value);
}

class LinkedList<T> extends IterableBase<T> {
	_Node<T>? _head;
	_Node<T>? _tail;
	int length = 0;

	LinkedList();

	factory LinkedList.from(Iterable<T> items) {
		final list = LinkedList<T>();
		for (final it in items) {
			list.add(it);
		}
		return list;
	}

	factory LinkedList.filled(int n, T fill) {
		final list = LinkedList<T>();
		for (var i = 0; i < n; i++) list.add(fill);
		return list;
	}

	factory LinkedList.generate(int n, T Function(int) generator) {
		final list = LinkedList<T>();
		for (var i = 0; i < n; i++) list.add(generator(i));
		return list;
	}

	void add(T value) {
		final node = _Node<T>(value);
		if (_head == null) {
			_head = node;
			_tail = node;
		} else {
			_tail!.next = node;
			_tail = node;
		}
		length++;
	}

	T operator[](int index) {
		if (index < 0 || index >= length) throw RangeError.index(index, this);
		var cur = _head;
		var i = 0;
		while (cur != null && i < index) {
			cur = cur.next;
			i++;
		}
		return cur!.value;
	}

	void operator[]=(int index, T value) {
		if (index < 0 || index >= length) throw RangeError.index(index, this);
		var cur = _head;
		var i = 0;
		while (cur != null && i < index) {
			cur = cur.next;
			i++;
		}
		cur!.value = value;
	}

	bool get isEmpty => length == 0;
	bool get isNotEmpty => length != 0;

	T get first {
		if (_head == null) throw StateError('No elements');
		return _head!.value;
	}

	T get last {
		if (_tail == null) throw StateError('No elements');
		return _tail!.value;
	}

	void clear() {
		_head = null;
		_tail = null;
		length = 0;
	}

	Iterable<R> map<R>(R Function(T) f) sync* {
		var cur = _head;
		while (cur != null) {
			yield f(cur.value);
			cur = cur.next;
		}
	}

	LinkedList<R> mapped<R>(R Function(T) f) {
		return LinkedList<R>.from(map(f));
	}

	LinkedList<T> clone() => LinkedList<T>.from(iterable);

	Iterable<T> get iterable sync* {
		var cur = _head;
		while (cur != null) {
			yield cur.value;
			cur = cur.next;
		}
	}

	@override
	Iterator<T> get iterator => iterable.iterator;

	@override
	List<T> toList({bool growable = true}) => List<T>.from(iterable, growable: growable);
}
