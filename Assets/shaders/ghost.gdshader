shader_type spatial;

uniform vec4 emmission_color: source_color;
uniform float emmission_ammount: hint_range(0.0, 16.0) = 5.0;
uniform float rim_sharpness: hint_range(0.0, 16.0) = 3.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	EMISSION = emmission_color.rgb * emmission_ammount;
	ALPHA = pow(1.0 - dot(NORMAL, VIEW), rim_sharpness) * emmission_color.a;
	
	// A . B = |A| * |B| * cos(theta)
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
