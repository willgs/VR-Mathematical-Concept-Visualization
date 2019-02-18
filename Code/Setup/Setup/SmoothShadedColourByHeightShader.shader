// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Lit/Smooth Shaded Colour By Height"
{
	//Created By Jason Beetham
    Properties
	{
        _First("Highest Point",float) = 1
		_Second("Second Heighest",float) = 1
		_Third("Third Heighest",float) = 1
		_Fourth("Fourth Heighest",float) = 1
		_FirstC("Highest Point Colour", Color) = (0,0,0,1)
		_SecondC("Second Heighest Colour",Color) = (0,0,0,1)
		_ThirdC("Third Colour",Color) = (0,0,0,1)
		_FourthC("Fourth Colour",Color) = (0,0,0,1)
		_FifthC("Fifth Colour",Color) = (0,0,0,1)

        _GridThickness ("Grid Thickness", Float) = 0.01
      _GridSpacing ("Grid Spacing", Float) = 10.0
      _GridColour ("Grid Colour", Color) = (0.5, 1.0, 1.0, 1.0)
      _BaseColour ("Base Colour", Color) = (0.0, 0.0, 0.0, 0.0)
	}
		SubShader
		{
        Lighting on
        Tags { "Queue" = "Transparent" }

        
        Pass
        
			{
            Cull Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight
            
            struct appdata
			{
                float2 uv : TEXCOORD0;
                fixed4 diff : COLOR;
                float3 normal : NORMAL;
                float4 vertex : POSITION;
            };
            
            struct v2f
			{
                float2 uv : TEXCOORD0;
				fixed4 diff : COLOR;
				float3 normal : NORMAL;
                float4 vertex : POSITION;
            };
            
            float4 _FirstC;
            float4 _SecondC;
            float4 _ThirdC;
            float4 _FourthC;
            float4 _FifthC;
            float _Scale;
            float _First;
            float _Second;
            float _Third;
            float _Fourth;
            float _Fifth;
			float4 _Position;
            
            v2f vert(appdata v)
			{
				float4 tempPos = mul(unity_ObjectToWorld, float4(0,0,0,1));
				_Position = mul( unity_WorldToObject,tempPos);
                v2f OUT;
				OUT.normal = v.normal;
                OUT.vertex = UnityObjectToClipPos(v.vertex);
                if (v.vertex.y >= _First) {
					OUT.diff = lerp(_FirstC,_SecondC,(_First /v.vertex.y) +.1f);
                }


				else if (v.vertex.y >= _Second && v.vertex.y < _First) {
					OUT.diff = lerp(_ThirdC,_SecondC, (v.vertex.y / _First));

                }


				else if (v.vertex.y >= _Third && v.vertex.y < _Second) {
                   OUT.diff = lerp(_FourthC,_ThirdC, (v.vertex.y / _Second));
                }


				else if (v.vertex.y <= _Third && v.vertex.y > _Fourth){
                     OUT.diff = lerp(_ThirdC,_FourthC, (v.vertex.y / _Third));
                }

				else {
                    OUT.diff = _FifthC;
                }

                return OUT;
            }
			
            fixed4 frag(v2f i) : SV_Target
            {
                float4 col = i.diff;
                half3 lightColor = ShadeVertexLights(i.vertex, i.normal);
                col.rgb *= lightColor;
                return col;
            }
            ENDCG
        }
        

        Pass {
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha
        Cull off
        CGPROGRAM
     
        // Define the vertex and fragment shader functions
        #pragma vertex vert
        #pragma fragment frag
     
        // Access Shaderlab properties
        uniform float _GridThickness;
        uniform float _GridSpacing;
        uniform float4 _GridColour;
        uniform float4 _BaseColour;
     
        // Input into the vertex shader
        struct vertexInput {
            float4 vertex : POSITION;
        };
 
        // Output from vertex shader into fragment shader
        struct vertexOutput {
          float4 pos : SV_POSITION;
          float4 worldPos : TEXCOORD0;
        };
     
        // VERTEX SHADER
        vertexOutput vert(vertexInput input) {
          vertexOutput output;
          output.pos = UnityObjectToClipPos(input.vertex);
          // Calculate the world position coordinates to pass to the fragment shader
          output.worldPos = 
          mul(unity_ObjectToWorld, input.vertex);
          return output;
        }
 
        // FRAGMENT SHADER
        float4 frag(vertexOutput input) : COLOR {
          if (frac(input.worldPos.x/_GridSpacing) < _GridThickness || frac(input.worldPos.z/_GridSpacing) < _GridThickness) {
            return _GridColour;
          }
          else {
            return _BaseColour;
          }
        }
        ENDCG
        }

}
}