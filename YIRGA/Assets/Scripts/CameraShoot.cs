using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraShoot : MonoBehaviour
{
    Camera secondCam;
    // Use this for initialization  
    void Start()
    {
        secondCam = GetComponent<Camera>();
    }

    // Update is called once per frame  
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            Fun(Camera.main, "MainCamera.png");
            Fun(secondCam, "SecondCamera.png");
        }
    }

    void Fun(Camera m_Camera, string filename)
    {
        RenderTexture rt = new RenderTexture(Screen.width, Screen.height, 16);
        m_Camera.targetTexture = rt;
        m_Camera.Render();

        RenderTexture.active = rt;
        Texture2D t = new Texture2D(Screen.width, Screen.height);
        t.ReadPixels(new Rect(0, 0, t.width, t.height), 0, 0);
        t.Apply();

        string path = Application.streamingAssetsPath + "/" + filename;
        System.IO.File.WriteAllBytes(path, t.EncodeToPNG());
    }
}