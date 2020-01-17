// https://roystan.net/articles/grass-shader.html
// https://halisavakis.com/my-take-on-shaders-geometry-shaders/
// https://halisavakis.com/my-take-on-shaders-geometry-shaders/

Shader "Grass"
{
    Properties
    {
		[Header(Shading)]
        _TopColor("Top Color", Color) = (1,1,1,1)
		_BottomColor("Bottom Color", Color) = (1,1,1,1)
		_TranslucentGain("Translucent Gain", Range(0,1)) = 0.5
    }

	CGINCLUDE
	#include "UnityCG.cginc"
	#include "AutoLight.cginc" 

	struct vertexInput {
		float4 vertex : POSITION;
		float3 normal : NORMAL;
		float4 tangent : TANGENT;
	};

	struct vertexOutput {
		float4 vertex : SV_POSITION;
		float3 normal : NORMAL;
		float4 tangent : TANGENT;
	};

	struct geometryOutput { 
		float4 pos : SV_POSITION; 
		float2 uv : TEXCOORD0;
	};

	geometryOutput makeVertex(float3 pos, float2 uv) {
		geometryOutput o;
		o.pos = UnityObjectToClipPos(pos);
		o.uv = uv;
		return o;
	}

	[maxvertexcount(3)]
	void geo(triangle vertexOutput IN[3], inout TriangleStream<geometryOutput> triStream)
	{
		float4 vPos = IN[0].vertex;
		float3 vNor = IN[0].normal;
		float4 vTan = IN[0].tangent;
		float3 vBinormal = cross(vNor, vTan) * vTan.w;
		float3x3 tangentToLocal = float3x3(
			vTan.x, vBinormal.x, vNor.x,
			vTan.y, vBinormal.y, vNor.y,
			vTan.z, vBinormal.z, vNor.z
		);
	
		float width = 0.1;
		triStream.Append(makeVertex(vPos + mul(tangentToLocal, float3(width, 0, 0)),  float2(0,  0)));
		triStream.Append(makeVertex(vPos + mul(tangentToLocal, float3(-width, 0, 0)), float2(1,  0)));
		triStream.Append(makeVertex(vPos + mul(tangentToLocal, float3(0, 0, 1)), 	  float2(.5, 1)));
	}
	
	vertexOutput vert(vertexInput vertex)
	{
		vertexOutput o;
		o.vertex  = vertex.vertex;
		o.normal  = vertex.normal;
		o.tangent = vertex.tangent;
		return o;
	}
	ENDCG

    SubShader
    {
		Cull Off

        Pass
        {
			Tags
			{
				"RenderType" = "Opaque"
				"LightMode" = "ForwardBase"
			}

            CGPROGRAM
            #pragma vertex vert
            #pragma geometry geo
			#pragma fragment frag
			#pragma target 4.6
            
			#include "Lighting.cginc"

			float4 _TopColor;
			float4 _BottomColor;
			float _TranslucentGain;

			float4 frag (geometryOutput vertex, fixed facing : VFACE) : SV_Target
            {	
				return float4(vertex.uv, 1, 1);
            }
            ENDCG
        }
    }
}