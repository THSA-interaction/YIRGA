// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "YIRGA/MountainShader" {
	Properties{
		_DrawLine("Draw Line", 2D) = "white" {}
		_Blue("Blue", Color) = (0, 0, 1, 1)
		_Green("Green", Color) = (0, 1, 0, 1)
		_LineDepth("Line Depth", Range(0.0, 1)) = 0.9
		_ColorDepth("Color Depth", Range(0.0, 1)) = 0.9
		_Brae("Brae", Range(5.0, 200)) = 50
		_Peak("Peak", Range(5.0, 200)) = 100
		_LightMult("Light Mult", Range(0.0, 1)) = 0.2
		_LightGain("Light Gain", Range(0.0, 2)) = 0.8
	}
	SubShader{
		Pass{
			Tags{ "LightMode" = "ForwardBase" }

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"

			sampler2D _DrawLine;
			float4 _DrawLine_ST;
			fixed4 _Blue;
			fixed4 _Green;
			float _LineDepth;
			float _ColorDepth;
			float _Brae;
			float _Peak;
			float _LightMult;
			float _LightGain;

			sampler2D _CameraDepthTexture;

			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				float3 worldNormal : TEXCOORD0;
				float3 worldPos : TEXCOORD1;
				float2 uv : TEXCOORD2;
			};

			v2f vert(a2v v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.uv = v.texcoord.xy * _DrawLine_ST.xy + _DrawLine_ST.zw;
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

				fixed3 paper = UNITY_LIGHTMODEL_AMBIENT.xyz*(1 - height1 * _ColorDepth);

				fixed3 albedo = (_Green * green + _Blue * blue) * _ColorDepth;

				fixed3 diffuse = _LightColor0.rgb * albedo * saturate(dot(worldNormal, worldLightDir) * _LightMult + _LightGain);

				//float depth = UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.uv));
				//depth = Linear01Depth(depth);
				//uint a = depth * 1000;
				//a = 9 - a % 10;
				//a = saturate(a);
				//a = i.worldNormal.y *2 + a;
				//fixed3 drawline = fixed3(a, a, a);
				//drawline = saturate(drawline);

				//uint b = i.worldPos.z * 5 + 50000;
				//b = 9 - b % 10;
				//fixed c = b + i.worldNormal.y + 0.5;
				//fixed3 drawline = fixed3(c, c, c);
				//drawline = saturate(drawline);

				//fixed d = i.worldNormal.y * 0.3;
				//fixed3 e = fixed3(d, d, d);
				//fixed3 drawline1 = tex2D(_DrawLine, i.uv).rgb + e;
				//drawline1 = saturate(drawline1);
				//drawline1 *= fixed3(_LineDepth, _LineDepth, _LineDepth);
				//drawline1 += fixed3(1 - _LineDepth, 1 - _LineDepth, 1 - _LineDepth);

				//fixed f = i.worldNormal.z;
				//fixed f1 = abs(f);
				//f1 = saturate(f1 * 50);
				//fixed f2 = abs(f - 0.6);
				//f2 = saturate(f2 * 50);
				//fixed f3 = abs(f + 0.6);
				//f3 = saturate(f3 * 50);
				//f = (f1 + f2 + f3) / 3;
				//f += saturate(((_Brae - i.worldPos.y) +60)/ 200);
				//f = saturate(f);
				//fixed3 drawline = fixed3(f, f, f);

				//drawline += drawline1 - 1;

				fixed g = saturate(abs(i.worldNormal.z) - 0.75);
				g += saturate(((_Brae - i.worldPos.y) + 60) / 160);
				fixed3 h = fixed3(g, g, g);
				fixed3 drawline = tex2D(_DrawLine, i.uv).rgb + h;
				drawline = saturate(drawline);
				drawline *= fixed3(_LineDepth, _LineDepth, _LineDepth);
				drawline += fixed3(1 - _LineDepth, 1 - _LineDepth, 1 - _LineDepth);

				return fixed4((paper + diffuse) * drawline, 1.0);
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}