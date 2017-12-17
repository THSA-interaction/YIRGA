using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimationControl : MonoBehaviour {
    FogWithNoise fog;
    public float speed = 1;
    private int count = 0;

    // Use this for initialization
    void Start () {
        fog = FindObjectOfType<FogWithNoise>();
        fog.fogDensity = 3;
        fog.fogEnd = 638;
	}
	
	// Update is called once per frame
	void Update () {
        count += 1;
        if (fog.fogDensity > 0.1) fog.fogDensity -= speed * 0.01f;
        if (fog.fogEnd > 58) fog.fogEnd -= speed * 2;
        if (transform.position.z >= 200) transform.Translate(new Vector3(0, 0, speed * 1));
        if (transform.position.y >= 60) transform.Translate(new Vector3(0, -speed * 0.2f, 0));
    }
}
