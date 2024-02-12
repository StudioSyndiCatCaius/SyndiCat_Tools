--flow asset example
local t={
	nodes={
		{
			class="Start",
			position={0,0},
		},
		{
			class="End",
			position={100,0},
		},
		{
			class="dialog",
			position={50,0},
			fields={
				speaker="Fellow",
				line="Hello!",
			},
		},
		{
			class="dialog",
			position={100,0},
			fields={
				speaker="Fellow",
				line="How are you today?!",
			},
		},
		{
			class="choice_hub",
			position={150,0},
			fields={
			},
		},
		{
			class="choice",
			position={200,100},
			fields={
				text="Good",
			},
		},
		{
			class="choice",
			position={200,-100},
			fields={
				text="bad"
			},
		},
		{
			class="dialog",
			position={300,100},
			fields={
				speaker="Awesome!",
				line="Hello!",
			},
		},
		{
			class="dialog",
			position={300,-100},
			fields={
				speaker="Aww. That's too bad.",
				line="Hello!",
			},
		},
		{
			class="dialog",
			position={350,0},
			fields={
				speaker="Well, see ya!",
				line="Hello!",
			},
		},
	},
	connections={},
}


return t