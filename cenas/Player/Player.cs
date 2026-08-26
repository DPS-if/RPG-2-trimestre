using Godot;
using System;

public partial class Player : CharacterBody2D
{
	[Export]
	public float Speed = 150.0f;

	// Configurações de HP (10 hits de 10 de dano = 100 de vida total)
	[Export]
	public float MaxHp = 100.0f;
	private float _currentHp;

	private AnimatedSprite2D _animatedSprite;

	public override void _Ready()
	{
		_currentHp = MaxHp;
		_animatedSprite = GetNode<AnimatedSprite2D>("AnimatedSprite2D");
		
		// Garante que a animação idle comece a rodar assim que o jogo inicia
		_animatedSprite.Play("idle");
	}

	public override void _PhysicsProcess(double delta)
	{
		Vector2 direction = Input.GetVector("ui_left", "ui_right", "ui_up", "ui_down");

		if (direction != Vector2.Zero)
		{
			Velocity = direction * Speed;

			// Vira o personagem para o lado que ele está andando
			if (direction.X > 0)
			{
				_animatedSprite.FlipH = false; // Olha para a direita
			}
			else if (direction.X < 0)
			{
				_animatedSprite.FlipH = true;  // Olha para a esquerda
			}
		}
		else
		{
			Velocity = Vector2.Zero;
		}

		MoveAndSlide();
	}

	// Função chamada pelos zumbis quando te atingem
	public void TakeDamage(float amount)
	{
		_currentHp -= amount;
		GD.Print("Vida atual do Player: " + _currentHp);
		
		if (_currentHp <= 0)
		{
			Die();
		}
	}

	// Função chamada quando o HP chega a zero
	private void Die()
	{
		GD.Print("O player morreu!");
		GetTree().ReloadCurrentScene();
	}
}
