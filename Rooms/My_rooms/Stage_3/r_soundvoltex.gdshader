shader_type canvas_item;

uniform vec2 screen_position;

void vertex() {
//	float center = 384.0;
//	float scaled = ((VERTEX.x * 2.0) - 1.0);
//	float off_center = screen_position.x + scaled - center;
//	float height = (screen_position.y + 200.0 + VERTEX.y)/2.0;
//
//	float attempt = scaled*10.0 - off_center * height*0.04;
//	VERTEX.x = 0.1*attempt - off_center;

	float center = 384.0;
	float off_center = screen_position.x + VERTEX.x - center;
	float height = VERTEX.y + 000.0 + screen_position.y;
	
	// at VERTEX.y = -100, we want vertex to equal 384 for all, ie off_center is 0
	VERTEX.x = center+off_center-screen_position.x;// + (off_center * height)/1000.0;
	
}