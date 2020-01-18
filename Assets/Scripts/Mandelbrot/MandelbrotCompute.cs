using UnityEngine;

public class MandelbrotCompute : MonoBehaviour
{
    public Renderer rend;
    public RenderTexture outputTexture;
    public ComputeShader shader;

    private int _kiCalc;
    public int textSize = 1024;
    private static readonly int MainTex = Shader.PropertyToID("_MainTex");
    
    public Transform cursor;

    // Start is called before the first frame update
    private void Start()
    {
        outputTexture = new RenderTexture(textSize, textSize, 32) {enableRandomWrite = true};
        outputTexture.Create();
        rend = GetComponent<Renderer>();
        rend.enabled = true;
        
        _kiCalc = shader.FindKernel("pixelCalc");
        shader.SetTexture(_kiCalc, "textureOut", outputTexture);
        shader.SetFloat("_textSize", textSize);
    }

    // Update is called once per frame
    private void Update()
    {
        var pos = cursor.position * .25f;
        shader.SetVector("startingPoint", new Vector4(pos.x, pos.z));

        shader.Dispatch(_kiCalc, textSize / 32, textSize / 32, 1);
        rend.material.SetTexture(MainTex, outputTexture);
    }
}
