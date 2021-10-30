
using UnityEngine;
using UnityEngine.SceneManagement;

public class FadeTest : MonoBehaviour {

	public Texture fadeImage;
	public float fadeSpeed = 1.5f;
	public int changedSceneIndex;

	private bool isSceneStarting = false;
	private bool isSceneEnding = false;
	private float GUIColorAlpha;

	// Use this for initialization
	void Start () {

		GUIColorAlpha = GUI.color.a;
		GUIColorAlpha = 0.0f;

		DontDestroyOnLoad (this.gameObject);
	}
	
	// Update is called once per frame
	void Update () {

		if (isSceneStarting == true) {

			StartScene ();
		}

		if (isSceneEnding == true){

			EndScene ();
		}

		if(Input.GetKeyDown (KeyCode.L)){
			
			isSceneStarting = false;
			isSceneEnding = true;
		}
	}

	void FadeToWhite() {
		
		GUIColorAlpha = Mathf.Lerp (GUIColorAlpha, 0.0f, fadeSpeed * Time.deltaTime);
	}

	void StartScene() {
		
		FadeToWhite ();

		if(GUIColorAlpha <= 0.05f){

			GUIColorAlpha = 0.0f;
			isSceneStarting = false;

			Destroy (this.gameObject);
		}
	}

	void FadeToBlack() {

		GUIColorAlpha = Mathf.Lerp (GUIColorAlpha, 1.0f, fadeSpeed * Time.deltaTime);
	}

	void EndScene() {

		FadeToBlack ();

		if(GUIColorAlpha >= 0.95f){

			GUIColorAlpha = 1.0f;
			isSceneStarting = true;
			isSceneEnding = false;

			SceneManager.LoadScene (changedSceneIndex);
		}
	}

	void OnGUI() {

		GUI.color = new Color (GUI.color.r, GUI.color.g, GUI.color.b, Mathf.Clamp01 (GUIColorAlpha));
		GUI.DrawTexture (new Rect(0,0, Screen.width, Screen.height), fadeImage);
	}

}
