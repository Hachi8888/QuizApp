//
//  ViewController.swift
//  QuizApp
//
//  Created by VERTEX22 on 2019/08/13.
//  Copyright © 2019 N-project. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // 問題表示画面のトップバー(第何問目かを表示させる)
    @IBOutlet weak var topBar: UINavigationItem!

    // ボタンが入っているStackViewを紐付け(配列で各ボタンが入っている状態)
    @IBOutlet weak var answersStackView: UIStackView!
    // クイズの番号を管理する番号
    var quizNum: Int = 0
    
    // 回答した問題の正誤を記録する
    var result: [String] = []

    // segueで問題の正誤を送る
    var sendResult: [String] = []
    

    // クイズを表示するテキストビュー
    @IBOutlet weak var quizTextView: UITextView!
    
    // 問題文(辞書のキー:何問目か、問題文、正解の問題番号、回答ボタンの数)
    let Quiz:[[String: Any]] = [
        ["QuizText": "日本の世界遺産『富士山－信仰の対象と芸術の源泉』は、2013年に（ ）として世界遺産登録されました。\n\n1. 文化遺産\n2. 自然遺産\n3. 山岳遺産\n4. 伝統遺産", "correctNum": 1,],
        ["QuizText": "イタリア共和国の世界遺産『フィレンツェの歴史地区』のあるフィレンツェを中心に、17世紀に栄えた芸術運動は何でしょうか。\n\n1. シュルレアリスム \n2. アバンギャルド \n3. ルネサンス", "correctNum": 3],
        ["QuizText": "2016年のオリンピック開催地であるリオ・デ・ジャネイロで、ブラジル独立100周年を記念して作られたキリスト像が立つ場所として、正しいものはどれか。\n\n1. コパカバーナの山 \n2. コルコバードの丘", "correctNum": 2]
    ]

    
    // アプリを立ち上げたら問題を表示する
    override func viewDidLoad() {
        super.viewDidLoad()

        showQuiz()
    }

    override func viewDidDisappear(_ animated: Bool) {
        showQuiz()
    }
    
    // 問題画面を表示させる関数
    func showQuiz() {
        /* quizNumをもとに、Quizの辞書から現在の問題を特定する。
         特定したCurrentQuizは、現在のクイズ番号の問題内容が配列で入っている。*/
        var CurrentQuiz = Quiz[quizNum]
        
        // 問題のタイトルを表示
        self.topBar.title = "第\(quizNum + 1)問"
        // 問題文を表示 :CurrentQuizから、"QuizText"をキーに取り出し表示する。
        quizTextView.text = CurrentQuiz["QuizText"]! as? String
    }

    /// 画面に表示させるボタンを1つ減らす処理
    func hideButton() {
        /// どのボタンを消すかを決める
        /// * ボタンの総数　ー　問題番号
        let hideButtonNumber: Int = answersStackView.arrangedSubviews.count - quizNum - 1
        // {(スタックビューの要素数) - (問題番号)}番目のボタンを隠す
        answersStackView.arrangedSubviews[hideButtonNumber].isHidden = true
    }

    // 正解のアラートを表示する関数
    func correctAlert() {
        // アラートの作成
        let alert = UIAlertController(title: "【祝】正解", message: "次に進みます", preferredStyle: .alert)
        // アラートのアクション(ボタンの定義)
        let OK = UIAlertAction(title: "OK", style: .cancel, handler: {(action: UIAlertAction) in

            // 結果を記録する
            self.result.append("第\(self.quizNum + 1)問:◯")
            self.hideButton()
            // 問題を進める
            self.quizNum += 1

            // 最後の問題かどうかを判定
            if self.quizNum < self.Quiz.count {
                // 次の問題を表示する
                self.showQuiz()
            } else {
                // 最後の問題なので結果画面へ遷移する
                self.performSegue(withIdentifier: "showResult", sender: nil)
                // リセット
                self.reset()
            }

        })
        // 作成したalertにOKボタンを追加
        alert.addAction(OK)
        // アラートを表示する
        present(alert, animated: true, completion: nil)

    }

    // 不正解のアラートを表示させる関数
    func wrongAlert() {
        // アラートの作成
        let alert = UIAlertController(title: "不正解", message: "次の問題に進みますか?", preferredStyle: .alert)

        // アラートの中の進むボタンを定義 (styleは .defaultで設定すること)
        let nextQ = UIAlertAction(title: "進む", style: .default
            , handler: {(action: UIAlertAction!) in
                // 進むを押したときの処理

                // 結果を記録する
                self.result.append("第\(self.quizNum + 1)問:☓")

                self.hideButton()
                // 問題番号を進める
                self.quizNum += 1
                // 最後の問題を回答していれば、結果の画面に遷移する。最後の問題でなければ次の問題へ進む。
                if self.quizNum >= self.Quiz.count {
                    // 最後の問題なので結果画面へ遷移する
                    self.performSegue(withIdentifier: "showResult", sender: nil)
                    // リセット
                    self.reset()
                } else {
                    // 次の問題を表示する
                    self.showQuiz()
                }
                
        })

        // やり直しボタンを定義(押しても何も処理しない)
        let backQ = UIAlertAction(title: "やり直す", style: .default
            , handler: nil)

        // 作成したalertに進むボタン、やり直しボタンを追加
        alert.addAction(nextQ)
        alert.addAction(backQ)

        // アラートを表示する
        present(alert, animated: true, completion: nil)
    }

    // 正誤の結果を表示したあとにリセットする関数
    func reset() {
        quizNum = 0
        result = []
        sendResult = []

        for button in answersStackView.arrangedSubviews {
            button.isHidden = false
        }
    }

    // 正誤判定:1~4のボタンを紐付け(タグ番号をそれぞれ0〜3で付与)
    @IBAction func selectAnswer(_ sender: UIButton) {
        
        // quizNumをもとに、Quizの辞書から現在の問題内容を特定する
        var CurrentQuiz = Quiz[quizNum]
        
        // 回答の正誤を判定
        let yourAnswer = sender.tag + 1  // 選択したボタンの数字は、押したボタンのタグ番号に+1で取得
        if yourAnswer == CurrentQuiz["correctNum"] as! Int {
            // 正解
            correctAlert()
        } else {
            // 不正解
            wrongAlert()
        }
    }

    // segue遷移準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showResult" , let vc = segue.destination as? ResultTableViewController else {
            return
        }
        // 回答結果を遷移先のVCにわたす
        sendResult = result
        vc.catchResult = sendResult
    }

}

