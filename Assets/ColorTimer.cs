using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ColorTimer : MonoBehaviour
{
    Material material;

    private float timer; 
    // Start is called before the first frame update
    void Start()
    {
        timer = 3;
        material = GetComponent<Renderer>().material;
    }

    // Update is called once per frame
    void Update()
    {
        timer -= Time.deltaTime;
        if (timer >= 3)
        {
            var color = material.GetColor("_BaseColor");
            color = Color.white;
        }
        else if (timer >= 2)
        {
            material.color = Color.yellow;
        }
        
        else if(Mathf.Approximately(timer, 1))
        {
            material.color = Color.green;
            this.gameObject.SetActive(false);
        }
        
    }
}
