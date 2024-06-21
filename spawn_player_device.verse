using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Fortnite.com/FortPlayerUtilities }
using { /Fortnite.com/Game }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation }

spawn_player_device := class(creative_device):
    @editable GameStartLobbyTimer : timer_device = timer_device{}
    @editable GameStartLobbySpawners : []player_spawner_device = array{}

    OnBegin<override>()<suspends>:void=
        GameStartLobbyTimer.SuccessEvent.Subscribe(OnGameStartTimerComplete)


    OnGameStartTimerComplete(Agent : ?agent):void=
        for (Spawner : GameStartLobbySpawners):
            Spawner.SpawnedEvent.Subscribe(OnPlayerSpawned)

        DisableRespawns()

    RespawnAllPlayers()<suspends>:void=
        for (Spawner : GameStartLobbySpawners):
            Spawner.Enable()
        TeamCollection := GetPlayspace().GetTeamCollection()
        Teams := TeamCollection.GetTeams()
        for (Index -> Team : Teams, Index <> 2): # Team 2 is the spectators
            for (Agent : TeamCollection.GetAgents[Team]):
                Agent.Respawn(vector3{}, rotation{})
                Sleep(0.01)

                if(Character := Agent.GetFortCharacter[]):
                    Character.SetVulnerability(true)
                    Sleep(0.01)
                    Character.Damage(damage_args{
                        Amount := 999999999.0, 
                        Instigator := option{Character}, 
                        Source := option{Character}})


    OnPlayerSpawned(Agent : agent):void=
        Print("")

    DisableRespawns():void=
        Print("")
