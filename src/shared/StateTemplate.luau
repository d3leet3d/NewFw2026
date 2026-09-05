local StateTemplate = {}

function StateTemplate.New()
	return {}
end

function StateTemplate.SessionData()
	return {}
end

export type Data =
	typeof(StateTemplate.New())
	& typeof(StateTemplate.SessionData())

return StateTemplate
