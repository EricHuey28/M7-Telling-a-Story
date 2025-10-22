@icon('./health_component_example.svg')
## A component that can be added to any node to give it a health property.
## 
## The Health component is a convenient quick shortcut for any unit or player
## to obtain the ability of having health and getting damage.
## [br]
## Has two main function, [member heal] and [member take_damage]. When 
## [member health] reaches zero, the class emits [signal has_died].
## [br]
##
## This class does nothing on its own, it expects another node to connect to the
## signal and react.
class_name HealthComponentExample extends Area2D

## Represents the entity's life. When it reaches 0, the entity is considered 
## dead
@export var health := 10

## When healing, health will not go over this amount.
@export var health_max := 10

## Becomes true when health reaches 0
var is_dead := false

## Emitted when health reaches 0
signal has_died


## Increments [member health].
## [param healing_amount]: should be a positive integer.
## To remove health point, use [member take_damage]
func heal(healing_amount: int) -> void:
	health += healing_amount
	if health > health_max:
		health = health_max


## Decrements [member health].
## [param damage_amount]: should be a positive integer.
## To increase health point, use [member heal]. [br]
## If health reaches zero, [member is_dead] will be set to [code]true[/code]
## and the [signal has_died] will be dispatched.
func take_damage(damage_amount: int) -> void:
	health -= damage_amount
	if health <= 0:
		health = 0
		is_dead = true
		has_died.emit()
