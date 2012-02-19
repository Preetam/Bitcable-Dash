if @error
	h1 -> "Something went wrong."
	p -> @error
else
	p -> "It worked."
