package lime.graphics;


enum RenderContext {
	
	OPENGL (gl:GLRenderContext);
	CANVAS (context:CanvasRenderContext);
	DOM (element:DOMRenderContext);
	FLASH (stage:FlashRenderContext);
	CAIRO (cairo:#if lime_cairo CairoRenderContext #else Dynamic #end);
	CONSOLE (context:#if lime_console ConsoleRenderContext #else Dynamic #end);
	CUSTOM (data:Dynamic);
	NONE;
	
}