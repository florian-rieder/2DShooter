extends Area2D

export (Resource) var powerup

func _on_Powerup_body_entered(body):
    if powerup == null:
        print('NO POWERUP ATTACHED')
        return
    if "Player" in body.get_groups():
        body.call('powerup', powerup)
        queue_free()
