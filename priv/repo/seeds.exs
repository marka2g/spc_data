# mix run priv/repo/seeds.exs

alias SpcData.Repo
alias SpcData.Equipment

for i <- 1..1000 do
  Repo.insert(%Equipment{model: "Equipment # #{i}"})
end
