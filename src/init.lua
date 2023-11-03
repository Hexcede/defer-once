--!strict

--- Takes in a callback and returns a new closure which will defer & call the callback exactly one time per defer period. Subsequent calls overwrite the arguments used.
local function DeferOnce<A...>(callback: (A...) -> ...any): (A...) -> ()
	local isDeferred = false
	local args: { any } & { n: number } = {} :: any

	local function deferOnce(...)
		-- Update with the most recent arguments
		args = table.pack(...)

		-- If the callback is already deferred, cancel
		if isDeferred then
			return
		end

		-- Mark that the callback is deferred
		isDeferred = true

		-- Defer & call the callback
		task.defer(function()
			-- Mark that the callback is no longer deferred
			isDeferred = false

			-- Call the callback with the most recent arguments
			callback(table.unpack(args, 1, args.n))
		end)
	end

	return deferOnce
end

return DeferOnce