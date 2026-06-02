using Godot;
using System;

public partial class TelaInicial : Control
{
	public override void _Ready()
	{
		var quitBtn = GetNode<TextureButton>("MarginContainer/HBoxContainer/VBoxContainer/quit_btn");
		quitBtn.Pressed += () => GetTree().Quit();
	}
}
