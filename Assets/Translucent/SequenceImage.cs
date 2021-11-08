//*********************❤*********************
// 
// 文件名（File Name）：	SequenceImage.cs
// 
// 作者（Author）：			LoveNeon
// 
// 创建时间（CreateTime）：	2017年8月17日12:31:39
// 
// 说明（Description）：	播放序列帧，支持循环、乒乓。事件待添加……
// 
//*********************❤*********************

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SequenceImage : MonoBehaviour {

    public enum PLAYSTATE
    {
        ONCE = 0,
        LOOP,
        PINGPONG
    }

    [Tooltip("目标对象")] public Image m_image;
    
    [Header("设置")]
    [Tooltip("自动播放")] public bool m_bAutoPlay = false;
    [Tooltip("播放方式")] public PLAYSTATE m_state = PLAYSTATE.ONCE;
    [Tooltip("帧数")][Range(1, 30)] public int m_frameCount = 21;
    
    [Header("图集")]
    [Tooltip("序列帧图片集")][SerializeField] private List<Sprite> m_array_sprite;

    //---------------------公有变量 -- 非序列号
    [System.NonSerialized] public int FrameIndex = 0;//当前帧
    [System.NonSerialized] public int FrameCount = 0;//总帧数
    //---------------------私有变量
    private bool m_bIsPlayer = false;//是否正在播放
    private float m_frameSecond = 0.045f;//帧秒

	// 初始运算
	void Awake () {
        m_frameSecond = 1.0f / m_frameCount;//获取每一张图片的持续时间
        FrameCount = m_array_sprite.Count;//获取总帧数
        if (m_bAutoPlay)//如果自动开始 则开始播放
            Play();
	}
	
    /// <summary>
    /// 开始播放序列帧
    /// </summary>
    public void Play()
    {
        m_bIsPlayer = true;//记录是否在播放
        StartCoroutine(PlayUpdate());//开始更新
    }

    /// <summary>
    /// 暂停播放
    /// </summary>
    public void Pause()
    {
        m_bIsPlayer = false;//记录是否在播放
        StopAllCoroutines();//停止协程
    }

    /// <summary>
    /// 停止播放
    /// </summary>
    public void Stop()
    {
        m_bIsPlayer = false;//记录是否在播放
        FrameIndex = 0;//返回为第一帧
        StopAllCoroutines();//停止协程
    }

    /// <summary>
    /// 是否正在播放
    /// </summary>
    public bool IsPlayer()
    {
        return m_bIsPlayer;
    }

    /// <summary>
    /// 设置为第几帧
    /// </summary>
    /// <param name="_frame"></param>
    public void SetFrame(int _frame)
    {
        //拒绝超出边界
        if (_frame >= FrameCount)
            _frame = FrameCount - 1;
        else if (_frame < 0)
            _frame = 0;
        FrameIndex = _frame;//保存
        ChangeImage();
    }
    
    /// <summary>
    /// 切换图片
    /// </summary>
    void ChangeImage()
    {
        //我没有进行判断越界和是否存在图片，1.我没有开放更改图片的接口，所以不存在图片失效，2.节省性能消耗
        m_image.sprite = m_array_sprite[FrameIndex];
    }

    /// <summary>
    /// 使用协程更新
    /// </summary>
    IEnumerator PlayUpdate()
    {
        float oldTime = Time.time;
        int addCount = 1;//增加帧量
        //死循环运算
        while (true)
        {
            #region 替换为下一张
            FrameIndex += addCount;//索引+ addCount  相当于+1  如果是pingpong 则可能addCount == -1
            //如果索引超出范围
            if (FrameIndex >= FrameCount || FrameIndex < 0)
            {
                //不同状态有不同的处理方式
                if (m_state == PLAYSTATE.ONCE)
                {
                    Stop();
                    break;
                }
                else if (m_state == PLAYSTATE.LOOP)
                {
                    FrameIndex = 0;//如果是循环则从0开始
                }
                else if (m_state == PLAYSTATE.PINGPONG)
                {
                    addCount *= -1;//反向增加
                    FrameIndex += addCount * 2;//当前已经超出边界，所以需要先变为上一张，然后再成为下一张   列：总帧数10 当前帧10  上一帧是9 那么这一帧 就得是8
                }
            }
            ChangeImage();//替换图片
            #endregion
            yield return new WaitForSeconds(m_frameSecond);//暂停协程,开始其他运算
        }
        yield return null;
    }

}
