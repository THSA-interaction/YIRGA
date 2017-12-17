using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScreenAfterEffects : MonoBehaviour {

	void Start () {
        Camera camera = GetComponent<Camera>();
        camera.depthTextureMode = DepthTextureMode.Depth;
	}
	
	void Update () {
		
	}
}
