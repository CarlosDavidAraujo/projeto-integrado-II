extends CharacterBody3D

var vida = 10
func hurt():
	vida = vida - 1
	print(vida)
