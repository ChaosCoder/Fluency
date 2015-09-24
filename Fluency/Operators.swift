import Foundation

infix operator → { associativity right precedence 150 }
infix operator ↯ { associativity right precedence 150 }
infix operator ∀ { associativity right precedence 150 }
infix operator | { associativity right precedence 160 }

func → (left: SequenceTask, right: Task!) -> SequenceTask {
	left.nextTask = right
	return left
}

func →<T> (left: (ChoiceTask<T>, T), right: Task) {
	left.0.nextTask[left.1] = right
}

func →<T> (left: ChoiceTask<T>, right: Task) {
	left.defaultTask = right
}

func → (left: FailableTask, right: Task?) -> FailableTask {
	left.successTask = right
	return left
}

func ↯ (left: FailableTask, right: Task?) -> FailableTask {
	left.failureTask = right
	return left
}

func ∀<T> (left: ForEachTask<T>, right: Task?) -> ForEachTask<T> {
	left.forEachTask = right
	return left
}

func → (left: SplitTask, right: Task) -> SplitTask {
	left.nextTasks.append(right)
	return left
}

func → (left: SplitTask, right: [Task]) -> SplitTask {
	for task in right
	{
		left.nextTasks.append(task)
	}
	return left
}

func | (left: Task, right: SplitTask) -> SplitTask {
	right.nextTasks.append(left)
	return right
}

func | (left: (SynchronizeTask, String), right: Task) -> SplitTask {
	let splitTask = SplitTask()
	splitTask → left
	splitTask → right
	return splitTask
}

func | (left: Task, right: (SynchronizeTask, String)) -> SplitTask {
	let splitTask = SplitTask()
	splitTask → left
	splitTask → right
	return splitTask
}

func | (left: (SynchronizeTask, String), right: (SynchronizeTask, String)) -> SplitTask {
	let splitTask = SplitTask()
	splitTask → left
	splitTask → right
	return splitTask
}

func | (left: Task, right: Task) -> SplitTask {
	let splitTask = SplitTask()
	splitTask.nextTasks.append(left)
	splitTask.nextTasks.append(right)
	return splitTask
}

func → (left: SplitTask, right: (SynchronizeTask, String)) -> SplitTask {
	left.nextTasks.append(right.0)
	right.0.addDependency(left, key: right.1)
	return left
}

func → (left: SequenceTask, right: (SynchronizeTask, String)) -> SequenceTask {
	left.nextTask = right.0
	right.0.addDependency(left, key: right.1)
	return left
}

func → (left: FailableTask, right: (SynchronizeTask, String)) -> FailableTask {
	left.successTask = right.0
	right.0.addDependency(left, key: right.1)
	return left
}

func →<T> (left: (ChoiceTask<T>, T), right: (SynchronizeTask, String)) -> (ChoiceTask<T>, T) {
	left.0.nextTask[left.1] = right.0
	right.0.addDependency(left.0, key: right.1)
	return left
}

func → (left: SplitTask, right: SynchronizeTask) -> SplitTask {
	left.nextTasks.append(right)
	right.addDependency(left)
	return left
}

func → (left: SequenceTask, right: SynchronizeTask) -> SequenceTask {
	left.nextTask = right
	right.addDependency(left)
	return left
}

func → (left: FailableTask, right: SynchronizeTask) -> FailableTask {
	left.successTask = right
	right.addDependency(left)
	return left
}

func →<T> (left: (ChoiceTask<T>, T), right: SynchronizeTask) -> (ChoiceTask<T>, T) {
	left.0.nextTask[left.1] = right
	right.addDependency(left.0)
	return left
}