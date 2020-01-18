using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FractalShaderController : MonoBehaviour
{
    public Renderer rend;

    private static readonly int CursorPositionX = Shader.PropertyToID("_cursorPositionX");
    private static readonly int CursorPositionY = Shader.PropertyToID("_cursorPositionY");
    private static readonly int Iterations = Shader.PropertyToID("_iterations");
    private static readonly int Selector = Shader.PropertyToID("_selector");
    private static readonly int Invert = Shader.PropertyToID("_invert");

    private int _selector = 0; 
    private int _invert = 0; 
    
    // Start is called before the first frame update
    void Start() { rend = GetComponent<Renderer> (); }

    // Update is called once per frame
    void Update()
    {
        var mousePosition = Input.mousePosition;

        if(Input.GetKeyDown(KeyCode.Space)) _selector++;
        if(Input.GetKeyDown(KeyCode.I)) _invert++;
        
        rend.material.SetFloat(CursorPositionX, mousePosition.x / Screen.width * 2 - 1);
        rend.material.SetFloat(CursorPositionY, mousePosition.y / Screen.height* 2 - 1);
        rend.material.SetInt(Iterations, 100);
        rend.material.SetInt(Selector, _selector % 2);
        rend.material.SetInt(Invert, _invert % 2);
    }
}
