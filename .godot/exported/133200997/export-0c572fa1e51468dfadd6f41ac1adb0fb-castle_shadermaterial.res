RSRC                    ShaderMaterial            ��������                                                  resource_local_to_scene    resource_name    code    script    render_priority 
   next_pass    shader    shader_parameter/start_frame    shader_parameter/end_frame    shader_parameter/current_frame    shader_parameter/specular    shader_parameter/metallic    shader_parameter/roughness     shader_parameter/clipping_plane    shader_parameter/offset_map    shader_parameter/normal_map     shader_parameter/texture_albedo    
   Texture2D     res://assets/castle/offsets.exr ��[`?u
   Texture2D     res://assets/castle/normals.png x[�:m�2
   Texture2D    res://assets/castle/albedo.png ���K��G   
   local://1 &      +   res://materials/castle_shadermaterial.tres          Shader          �  shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;

uniform sampler2D offset_map;
uniform sampler2D normal_map;
uniform sampler2D texture_albedo: source_color;

uniform float start_frame = 0;
uniform float end_frame = 96.0;
uniform float current_frame = 0;

uniform float specular;
uniform float metallic;
uniform float roughness : hint_range(0,1);

/*
 * Optional per-instance clipping plane - https://github.com/godotengine/godot/issues/3499
 * In this example, all negative Y pixels are discarded.
 */
uniform vec4 clipping_plane = vec4(0.0, 1.0, 0.0, 0.0);
bool culls(vec3 vertex, mat4 cam) {
	vec3 pos = (cam * vec4(vertex, 1.0)).xyz;
	return clipping_plane.x * pos.x
		+ clipping_plane.y * pos.y
		+ clipping_plane.z * pos.z
		+ clipping_plane.w < 0.0;
}

void vertex() {
	
	ivec2 tex_size = textureSize(offset_map, 0);
	float pixel_size = 1.0 / float(tex_size.y);
	
	float frame_floor = clamp(floor(current_frame), start_frame, end_frame);
	float frame_ceil = clamp(ceil(current_frame), start_frame, end_frame);
	
	vec2 frame_floor_uv_offset = vec2(0.0, -((frame_floor + 0.5) * pixel_size));
	vec2 frame_ceil_uv_offset = vec2(0.0, -((frame_ceil + 0.5) * pixel_size));
	
	float lerp_factor = current_frame - frame_floor;
	
	vec3 offset_floor = texture(offset_map, UV2 + frame_floor_uv_offset).xyz;
	vec3 offset_ceil = texture(offset_map, UV2 + frame_ceil_uv_offset).xyz;
	vec3 offset_lerp = mix(offset_floor, offset_ceil, lerp_factor);
	vec3 new_offset = vec3(offset_lerp.x, offset_lerp.z, offset_lerp.y);
	
	VERTEX += new_offset;
	
	vec3 normal_floor = texture(normal_map, UV2 + frame_floor_uv_offset).xyz;
	vec3 normal_ceil = texture(normal_map, UV2 + frame_ceil_uv_offset).xyz;
	vec3 normal_lerp = mix(normal_floor, normal_ceil, lerp_factor);
	vec3 new_normal = vec3((normal_lerp.x * 2.0) - 1.0, (normal_lerp.z * 2.0) - 1.0, (normal_lerp.y * 2.0) - 1.0);
	
	NORMAL = new_normal;
}

void fragment() {
	
	// Optional clipping plane, not required for vertex animation.
	if (culls(VERTEX, INV_VIEW_MATRIX)) {
		discard;
	}
	
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	ALBEDO = albedo_tex.rgb;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	SPECULAR = specular;
}
          ShaderMaterial                                                       �B	   )   �ݓ��VR@
         ?                  �?   2         �?                                                   RSRC