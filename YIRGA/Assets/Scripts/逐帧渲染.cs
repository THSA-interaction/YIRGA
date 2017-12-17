using UnityEngine;
using System.Collections;

public class 逐帧渲染 : MonoBehaviour
{

    public int 渲染时长 = 30;
    public float 时间流逝 = 0.08f;
    public string 输出路径;
    public int 帧率 = 30;
    private int 帧 = 1;
    private bool 停止 = false;
    private string 文件名称;

    void Start()
    {
        Invoke("停止渲染", 渲染时长);
        Time.timeScale = 0;
        if (帧 < 10) { 文件名称 = "0000" + 帧.ToString() + ".jpg"; }
        else if (帧 < 100) { 文件名称 = "000" + 帧.ToString() + ".jpg"; }
        else if (帧 < 1000) { 文件名称 = "00" + 帧.ToString() + ".jpg"; }
        else if (帧 < 10000) { 文件名称 = "0" + 帧.ToString() + ".jpg"; }
        else { 文件名称 = 帧.ToString() + ".jpg"; }
        ScreenCapture.CaptureScreenshot(输出路径 + 文件名称);
        帧++;
        Time.timeScale = 时间流逝;
        InvokeRepeating("渲染截图", 1f / (float)帧率, 1f / (float)帧率);
    }

    void Awake()
    {
        Application.targetFrameRate = 帧率;
    }


    void 渲染截图()
    {
        if (!停止)
        {
            Time.timeScale = 0;
            if (帧 < 10) { 文件名称 = "0000" + 帧.ToString() + ".png"; }
            else if (帧 < 100) { 文件名称 = "000" + 帧.ToString() + ".png"; }
            else if (帧 < 1000) { 文件名称 = "00" + 帧.ToString() + ".png"; }
            else if (帧 < 10000) { 文件名称 = "0" + 帧.ToString() + ".png"; }
            else { 文件名称 = 帧.ToString() + ".png"; }
            ScreenCapture.CaptureScreenshot(输出路径 + 文件名称);
            帧++;
            Time.timeScale = 时间流逝;
        }
    }

    void 停止渲染()
    {
        停止 = true;
        Time.timeScale = 0;
        CancelInvoke("渲染截图");
        Debug.Log("渲染完毕");
    }
}