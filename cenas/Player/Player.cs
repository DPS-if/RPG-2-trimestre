using Godot;
using System;

public partial class Player : CharacterBody2D
{
	[Export]
	public float Speed = 150.0f;

	[Export]
	public float MaxHp = 100.0f;
	private float _currentHp;

	private AnimatedSprite2D _animatedSprite;
	private Node _gameManager;

	public override void _Ready()
	{
		_currentHp = MaxHp;
		_animatedSprite = GetNode<AnimatedSprite2D>("AnimatedSprite2D");
		_animatedSprite.Play("idle");

		// Pega o GameManager global
		_gameManager = GetNodeOrNull("/root/GameManager");
		ReportHpToGameManager();
	}

	private void ReportHpToGameManager()
	{
		if (_gameManager != null)
		{
			_gameManager.Call("update_hp", _currentHp, MaxHp);
		}
	}

	public override void _PhysicsProcess(double delta)
	{
		Vector2 direction = Input.GetVector("ui_left", "ui_right", "ui_up", "ui_down");

		if (direction != Vector2.Zero)
		{
			Velocity = direction * Speed;

			if (direction.X > 0)
			{
				_animatedSprite.FlipH = false;
			}
			else if (direction.X < 0)
			{
				_animatedSprite.FlipH = true;
			}
		}
		else
		{
			Velocity = Vector2.Zero;
		}

		MoveAndSlide();
	}

	public void TakeDamage(float amount)
	{
		_currentHp -= amount;
		GD.Print("Vida atual do Player: " + _currentHp);
		ReportHpToGameManager(); // Atualiza a UI

		if (_currentHp <= 0)
		{
			Die();
		}
	}

	private void Die()
	{
		GD.Print("O player morreu!");
		
		// Carrega e instancia a cena de Game Over em C#
		var gameOverScene = GD.Load<PackedScene>("res://game_over.tscn");
		if (gameOverScene != null)
		{
			var gameOverInstance = gameOverScene.Instantiate();
			GetTree().CurrentScene.AddChild(gameOverInstance);
		}
		
		QueueFree();
	}
	}
