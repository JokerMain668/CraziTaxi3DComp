#ifndef CUSTOM_LIGHTING_INCLUDED
#define CUSTOM_LIGHTING_INCLUDED
#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
#pragma multi_compile _ _SHADOWS_SOFT

/*
#ifndef SHADERGRAPH_PREVIEW
	#if VERSION_GREATER_EQUAL(9, 0)
		#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
		#if (SHADERPASS != SHADERPASS_FORWARD)
			#undef REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR
		#endif
	#else
		#ifndef SHADERPASS_FORWARD
			#undef REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR
		#endif
	#endif
#endif
*/
void CalculateMainLight_float(float3 WorldPos, out float3 Direction, out float3 Colour, out half DistanceAtten, out half ShadowAtten) {
#if defined(SHADERGRAPH_PREVIEW)
	Direction = float3(0.5, 0.5, 0);
	Colour = 1;
	DistanceAtten = 1;
	ShadowAtten = 1;
#else
	#if SHADOWS_SCREEN
		half4 clipPos = TransformWorldToHClip(WorldPos);
		half4 shadowCoord = ComputeScreenPos(clipPos);
	#else
		half4 shadowCoord = TransformWorldToShadowCoord(WorldPos);
	#endif
	Light mainLight = GetMainLight(0);
	Direction = mainLight.direction;
	Colour = mainLight.color;
	DistanceAtten = mainLight.distanceAttenuation;
	ShadowAtten = mainLight.shadowAttenuation;
#endif
}

#endif