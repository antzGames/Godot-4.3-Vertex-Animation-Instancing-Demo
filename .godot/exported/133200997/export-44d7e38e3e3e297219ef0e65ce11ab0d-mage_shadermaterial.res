RSRC                    ShaderMaterial            ��������                                                  resource_local_to_scene    resource_name    code    script    render_priority 
   next_pass    shader    shader_parameter/time_scale    shader_parameter/frames    shader_parameter/specular    shader_parameter/metallic    shader_parameter/roughness    shader_parameter/offset_map    shader_parameter/normal_map     shader_parameter/texture_albedo    
   Texture2D    res://assets/mage/offsets.exr �ALEN��l
   Texture2D    res://assets/mage/normals.png }e�;��
   Texture2D    res://assets/mage/texture0.png ��"	6@�&   
   local://1 �      )   res://materials/mage_shadermaterial.tres �         Shader          �	  shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;

uniform sampler2D offset_map;
uniform sampler2D normal_map;
uniform sampler2D texture_albedo;
//uniform sampler2D texture_palette;

//uniform float start_frame = 0;
//uniform float end_frame = 6.0;
uniform float time_scale = 4.0;

uniform float frames = 40;

uniform float specular : hint_range(0,1);
uniform float metallic : hint_range(0,1);
uniform float roughness : hint_range(0,1);

varying flat vec4 custom_data;

vec4 EncodeFloatToRGBA( float v ) {
	float depth = v;
	return vec4(depth, fract(depth * 255.0), fract(depth * 65025.0), fract(depth * 16581375.0));
}

void vertex(){
	custom_data = INSTANCE_CUSTOM;

	float start_frame = frames * custom_data.g;
	float end_frame = start_frame + frames - 1.0;

	float time_int = 1.0;
	float time = modf(TIME * time_scale, time_int);
	float num_frames = end_frame - start_frame;
	float frame_offset = num_frames * custom_data.a;
	float current_frame = start_frame + mod((time * num_frames) + frame_offset, num_frames);

	ivec2 tex_size = textureSize(offset_map, 0);
	
	float pixel_size = 1.0 / float(tex_size.y);
	float frame_floor = clamp(floor(current_frame), start_frame+1.0, end_frame);
	float frame_ceil = clamp(ceil(current_frame), start_frame, end_frame-1.0);

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

void fragment(){
	vec3 albedo_col = texture(texture_albedo, UV).rgb;

	// tint color variation
	vec4 tint = EncodeFloatToRGBA(custom_data.a);
	albedo_col = mix(albedo_col,tint.xyz, 0.25);

	ALBEDO = albedo_col.rgb;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	SPECULAR = specular;
}

          ShaderMaterial                                              ?         B	   )   X9��v��?
   )   -����?   )   H�z�G�?                                           RSRC