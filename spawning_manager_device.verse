using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }

spawning_manager_device := class(creative_device):
    @editable RoundEndTrigger : trigger_device = trigger_device{}
    @editable GameStartLobbySpawners : []player_spawner_device = array{}
    @editable DeadlySpawners : []player_spawner_device = array{}
    @editable RoundEndLobbySpawners : []player_spawner_device = array{}
    @editable GameEndLobbySpawners : []player_spawner_device = array{}
    @editable GameStartLobbyTimer : timer_device = timer_device{}

    OnBegin<override>()<suspends>:void=
        GameStartLobbyTimer.SuccessEvent.Subscribe(OnGameStartTimerComplete)
        RoundEndTrigger.TriggeredEvent.Subscribe(OnRoundEnd)

    OnGameStartTimerComplete(Agent : ?agent):void=
        for (Spawner : GameStartLobbySpawners):
            Spawner.Disable()
        for (Spawner : DeadlySpawners):
            Spawner.Enable()
        GetPlayspace().PlayerAddedEvent().Subscribe(OnPlayerAdded)
    
    OnRoundEnd(Agent : ?agent):void=
        for (Spawner : DeadlySpawners):
            Spawner.Disable()
        for (Spawner : RoundEndLobbySpawners):
            Spawner.Enable()
        GetPlayspace().PlayerAddedEvent().Subscribe(OnPlayerAdded)
    
    OnPlayerAdded(Player : player):void=
        TeamCollection := GetPlayspace().GetTeamCollection()
        Teams := TeamCollection.GetTeams()
        for:
            Team : Teams, 
            TeamCollection.GetAgents[Team].Length < 2 and
            TeamCollection.AddToTeam[Player, Team]
        do:
            return
