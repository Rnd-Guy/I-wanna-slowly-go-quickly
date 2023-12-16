shader_type canvas_item;

uniform vec2 screen_position;

void vertex() {
	float center = 384.0;
	float global_x = screen_position.x + VERTEX.x;
	float off_center = global_x - center;
	float global_y = VERTEX.y + screen_position.y;
	
	// this gives us where we want our x to be
	float final_x = center + (off_center * (global_y+125.0)/580.0);
	VERTEX.x += final_x - global_x;
	
	
	//VERTEX.x = 10.0 + VERTEX.x;
	
	// at VERTEX.y = -100, we want vertex to equal 384 for all, ie off_center is 0
	//VERTEX.x = center+off_center-screen_position.x;// + (off_center * height)/1000.0;
	
}