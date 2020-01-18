Shader "Unlit/Mandelbrot"
{
    Properties
    {
        _cursorPositionX ("cursorPositionX", Range(-2, 2)) = 0
        _cursorPositionY ("cursorPositionY", Range(-2, 2)) = 0
        _iterations ("Iterations", Range(0, 1000)) = 0
        _selector ("Selector", Range(0, 1)) = 0
        _invert ("Invert", Range(0, 1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float3 getPixelMandelbrot(float2 pos, float2 start, int iter){
                int counter = 0;
                float2 val = start;
                for(counter = 0; counter < iter; counter++){
                    val = float2(val.x * val.x - val.y * val.y, 2 * val.x * val.y) + pos;
                    if(length(val) > 2) return float(counter) / iter;
                }    
                return 1.0;
            }

            float3 getPixelJulia(float2 pos, float2 start, int iter){
                int counter = 0;
                float2 val = pos;
                for(counter = 0; counter < iter; counter++){
                    val = float2(val.x * val.x - val.y * val.y, 2 * val.x * val.y) + start;
                    if(length(val) > 2) return float(counter) / iter;
                }    
                return 1.0;
            }
            
            float _cursorPositionX;
            float _cursorPositionY;
            int _iterations;
            int _selector;
            int _invert;

            fixed4 frag (v2f i) : SV_Target
            {
                float2 pos = i.uv * 8 - 4;
                float2 cursor = float2(_cursorPositionX, _cursorPositionY);
                float3 col =  _selector == 0 ? getPixelMandelbrot(pos, cursor, _iterations)
                                             : getPixelJulia(pos, cursor, _iterations);
                return _invert == 0 ? fixed4(col, 0) : fixed4(1 - col, 0);
            }
            ENDCG
        }
    }
}
