Shader "Custom/ColorVertexShader"
{
    Properties
    {
       
        _MainTex ("Texture", 2D) = "white" {}
      
    }
    SubShader
    {
        Tags { "RenderPipeline" = "UniversalRenderPipline" }
        
        Pass
        {
     HLSLPROGRAM
     # pragma vertex vert
     # pragma fragment frag

     #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

     struct appdata
     {
         float4 vertex : POSITION;
         float2 uv : TEXCOORD0;
     };

     struct v2f
     {
      float4 pos :SV_POSITION;
      float4 color: COLOR;
         float2 uv: TEXCOORD0;
     };

     TEXTURE2D(_MainTex);
     SAMPLER(sampler_MainTex);

     v2f vert(appdata v)
     {
         v2f o;
         o.pos = TransformObjectToHClip(v.vertex.xyz);
         o.uv = v.uv;
         o.color.r = sin(v.vertex.x + 10) / 10 * _Time;
         o.color.g = sin(v.vertex.x + 20) / 10 * _Time;
         o.color.b = sin(v.vertex.x + 30) / 10 * _Time;;
         o.color.a = 1.0;
         return o;
     }
     half4 frag(v2f i) :SV_Target
     {
         half texColor = SAMPLE_TEXTURE2D(_MainTex,sampler_MainTex,i.uv);
         return  texColor * i.color;
     }
        
     ENDHLSL
     }
    }
}