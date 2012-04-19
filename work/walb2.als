// walb2

abstract sig IOState {
	next: set IOState
}

one sig BEGIN extends IOState {}{
	next = CreatedWritePack
}
one sig CreatedWritePack extends IOState {}{
	next = CreatedLogPack
}
one sig CreatedLogPack extends IOState {}{
	next = CreatedDataPack + SubmittedLogPack
}
one sig CreatedDataPack extends IOState {}{
	next = ReadyToSubmitDataPack + DestroyedLogPack
}
one sig SubmittedLogPack extends IOState {}{
	next = CompletedLogPack
}
one sig CompletedLogPack extends IOState {}{
	next = DestroyedLogPack + ReadyToEnd
}
one sig DestroyedLogPack extends IOState {}{
	next = DestroyedWritePack
}
one sig ReadyToEnd extends IOState {}{
	next = ReadyToSubmitDataPack
}
one sig ReadyToSubmitDataPack extends IOState {}{
	next = SubmittedDataPack
}
one sig SubmittedDataPack extends IOState {}{
	next = CompletedDataPack
}
one sig CompletedDataPack extends IOState {}{
	next = EndedReqs + DestroyedDataPack
}
one sig EndedReqs extends IOState {}{
	next = DestroyedWritePack
}
one sig DestroyedDataPack extends IOState {}{
	next = DestroyedWritePack
}
one sig DestroyedWritePack extends IOState {}{
	next = END
}
one sig END extends IOState {}{
}

run {}
