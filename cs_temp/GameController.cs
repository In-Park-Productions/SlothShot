using System;
using System.Collections.Generic;
using Microsoft.Win32.SafeHandles;
#if UNITY_EDITOR
using UnityEditor;
#endif
using UnityEngine;
using UnityEngine.UI;

public class GameController : MonoBehaviour {
    #region Game Controller
    [Header("Settings")]
    public float initialSpeed = 3f;
    public float speedRate = 0.1f;
    public float maxSpeed = 10f;
    public float jaguarTimeInterval = 3f;
    public float eagleTimeInterval = 5f;
    public float foregroundDistInterval = 20f;
    public float vineDistInterval = 5f;

    [Header("State")]
    public bool isRunning = false;
    public float speed = 0f;
    public float score = 0f;
    public float distance = 0f;
    public float highscore {
        get { return PlayerPrefs.GetFloat("highscore", 0f); }
        set {
            PlayerPrefs.SetFloat("highscore", value);
            PlayerPrefs.Save();
        }
    }

    public float nextJaguar = float.MaxValue;
    public float nextEagle = float.MaxValue;
    public float nextForeground = float.MaxValue;
    public float nextVine = float.MaxValue;

    [Header("References")] 
    public GameObject startScreen;
    public GameObject gameOverScreen;
    public GameObject gameScreen;
    public Text highscoreLabel;
    public Text scoreLabel;
    public Text gameOverScoreLabel;
    public GameObject eaglePrefab;
    public GameObject vinePrefab;
    public GameObject foregroundPrefab;
    public GameObject jaguarPrefab;
    public Camera camera;
    public GameObject mainMenuBackdrop;
    public Transform world;

    [Header("Instance References")]
    public List<GameObject> foregroundSegments;
    public List<Vine> vines;
    public List<Eagle> eagles;
    public List<Jaguar> jaguars;
    public Sloth player;


    void Start() {
        startScreen.SetActive(true);
        gameOverScreen.SetActive(false);
        gameScreen.SetActive(false);
    }

    public void StartGame() {
        isRunning = true;
        speed = initialSpeed;
        score = 0f;
        distance = 0f;

        nextVine = vineDistInterval;
        nextJaguar = Time.time + jaguarTimeInterval;
        nextEagle = Time.time + eagleTimeInterval;
        nextForeground = 0f;

        highscoreLabel.text = "Highscore: " + Mathf.RoundToInt(highscore).ToString();
        scoreLabel.text = "Score: " + Mathf.RoundToInt(score).ToString();

        GameObject firstNewForeground = Instantiate(foregroundPrefab, world);
        firstNewForeground.transform.position = new Vector3(0, 0, 0);
        GameObject secondNewForeground = Instantiate(foregroundPrefab, world);
        secondNewForeground.transform.position = new Vector3(foregroundDistInterval, 0, 0);
    }

    void Update() {
        GameLoop();
    }

    public void GameLoop() {
        if (isRunning) {
            speed += Time.deltaTime * speedRate;
            if (speed > maxSpeed)
                speed = maxSpeed;
            distance += speed * Time.deltaTime;
            score = distance; 
            camera.transform.position = new Vector3(distance, 5f, -10f);

            if (Time.time > nextJaguar) {
                nextJaguar = Time.time + jaguarTimeInterval;
                // Spawn Jaguar
            }
            if (Time.time > nextEagle) {
                nextEagle = Time.time + eagleTimeInterval;
                // Spawn Eagle
            }
            if (distance > nextForeground) {
                nextForeground += foregroundDistInterval;
                GameObject newForeground = Instantiate(foregroundPrefab, world);
                newForeground.transform.position = new Vector3(nextForeground + foregroundDistInterval, 0, 0);
                foregroundSegments.Add(newForeground);
            }
            if (distance > nextVine) {
                nextVine += vineDistInterval;
                // Spawn Vine
            }

            scoreLabel.text = "Score: " + Mathf.FloorToInt(score).ToString();
            if (score > highscore)
                highscoreLabel.text = "Highscore: " + Mathf.FloorToInt(score).ToString();
        }
    }

    public void EndGame() {
        isRunning = false;
        bool isHighscore = score > highscore;
        if (isHighscore)
            highscore = score;

        gameScreen.SetActive(false);
        gameOverScreen.SetActive(true);

        gameOverScoreLabel.text = (isHighscore) ? "New Highscore!!!\nHighscore: " + Mathf.FloorToInt(score) : "Score: " + Mathf.FloorToInt(score) + "\nHighscore: " + Mathf.FloorToInt(highscore);
    }

    public void ResetGame() {
        camera.transform.position = Vector3.zero;
        foreach (GameObject foregroundSegment in foregroundSegments)
            Destroy(foregroundSegment);
        foregroundSegments.Clear();
    }
    #endregion

    #region UI Events

    public void StartGameButton_OnClick() {
        mainMenuBackdrop.SetActive(false);
        gameScreen.SetActive(true);
        gameOverScreen.SetActive(false);
        startScreen.SetActive(false);
        StartGame();
    }

    public void QuitGameButton_OnClick() {
#if UNITY_EDITOR
        EditorApplication.isPlaying = false;
#else
        Application.Quit();
#endif
    }

    public void GameOverButton_OnClick() {
        mainMenuBackdrop.SetActive(true);
        gameScreen.SetActive(false);
        gameOverScreen.SetActive(false);
        startScreen.SetActive(true);
        ResetGame();
    }
#endregion
}
