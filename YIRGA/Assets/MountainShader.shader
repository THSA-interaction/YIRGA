// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "YIRGA/MountainShader" {
	Properties{
		_Blue("Blue", Color) = (0, 0, 1, 1)
		_Green("Green",Color) = (0, 1, 0, 1)
		_Brae("Brae",Range(5.0, 200)) = 50
		_Peak("Peak",Range(5.0, 200)) = 100
		_LightMult("Light Mult",Range(0.0, 1)) = 0.2
		_LightGain("Light Gain",Range(0.0, 2)) = 0.8
	}
	SubShader{
		Pass{
			Tags{ "LightMode" = "ForwardBase" }

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"

			fixed4 _Blue;
			fixed4 _Green;
			float _Brae;
			float _Peak;
			float _LightMult;
			float _LightGain;

			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				float3 worldNormal : TEXCOORD0;
				float3 worldPos : TEXCOORD1;
			};

			v2f vert(a2v v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target{
				fixed3 worldNormal = normalize(i.worldNormal);
				fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
				fixed3 up = fixed3(0, 1, 0);

				fixed height1 = saturate(i.worldPos.y / _Brae);
				fixed height2 = saturate((i.worldPos.y - _Brae) / _Peak);
				fixed illumin = saturate(dot(worldNormal, worldLightDir) + dot(worldNormal, up));

				fixed blue = height2 + (1 - illumin);
				fixed green = height1 - blue;

				fixed3 paper = UNITY_LIGHTMODEL_AMBIENT.xyz*(1 - height1);

				fixed3 albedo = _Green * green + _Blue * blue;

				fixed3 diffuse = _LightColor0.rgb * albedo * saturate(dot(worldNormal, worldLightDir) * _LightMult + _LightGain);

				return fixed4(paper + diffuse, 1.0);
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}