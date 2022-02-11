using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using System.Data.Entity;
using System.IO;
using System.Web.UI;

namespace ChessGameManager.Controllers
{
    public class ChessGameController : Controller
    {
        ~ChessGameController()
        {
            if (db!=null)
            {
                db.Dispose();
            }
        }
        private readonly ModelContainer db = new ModelContainer();
        HttpCookie cookie = new HttpCookie("Warning");
        // GET: ChessGame
        public ActionResult Index()
        {
            if (db.People.Count() < 2)
            {
                Response.Write("<script>alert('You need to add atleast 2 players to create a game')</script>");
            }
            return View(db.ChessGames);
        }

        // GET: ChessGame/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            ChessGame chessGame = db.ChessGames
                .Include(cg => cg.UploadedFiles)
                .SingleOrDefault(cg => cg.IDChessGame == id);
            if (chessGame == null)
            {
                return HttpNotFound();
            }
            return View(chessGame);
        }

        // GET: ChessGame/Create
        public ActionResult Create()
        {
            var people = db.People;
            ViewBag.People = db.People;       
            if (people.Count() < 2)
            {
                return RedirectToAction("Index");
            }
            return View();
        }

        // POST: ChessGame/Create
        [HttpPost]
        public ActionResult Create(ChessGame chessGame,
            int firstPlayerID,
            int secondPlayerID,
            IEnumerable<HttpPostedFileBase> files)
        {
            chessGame.FirstPlayer = db.People.Find(firstPlayerID);
            chessGame.SecondPlayer = db.People.Find(secondPlayerID);
            if (ModelState.IsValid)
            {
                chessGame.UploadedFiles = new List<UploadedFile>();
                foreach (var file in files)
                {
                    if (file != null && file.ContentLength > 0)
                    {
                        var picture = new UploadedFile
                        {
                            Name = Path.GetFileName(file.FileName),
                            ContentType = file.ContentType
                        };
                        using (var reader = new BinaryReader(file.InputStream))
                        {
                            picture.Content = reader.ReadBytes(file.ContentLength);
                        }
                        chessGame.UploadedFiles.Add(picture);
                    }
                }

                db.ChessGames.Add(chessGame);
                db.SaveChanges();

            }
            return RedirectToAction("Index");  
        }

        // GET: ChessGame/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            
            ChessGame chessGame = db.ChessGames
                .Include(cg => cg.UploadedFiles)
                .SingleOrDefault(cg => cg.IDChessGame == id);
            if (chessGame == null)
            {
                return HttpNotFound();
            }
            IEnumerable<Person> people = db.People.Where(p => p.IDPerson != chessGame.FirstPlayer.IDPerson);
            people = people.Prepend(chessGame.FirstPlayer);

            ViewBag.People1 = people;

            people = people.Where(p => p.IDPerson != chessGame.SecondPlayer.IDPerson);
            people = people.Prepend(chessGame.SecondPlayer).ToList();

            ViewBag.People2 = people;


            return View(chessGame);
        }

        // POST: ChessGame/Edit/5
        [HttpPost]
        [ActionName("Edit")]
        public ActionResult EditConfirmed(int id,
            int firstPlayerID,
            int secondPlayerID,
            IEnumerable<HttpPostedFileBase> files)
        {
            ChessGame chessGameToUpdate = db.ChessGames.Find(id);
            if (TryUpdateModel(chessGameToUpdate, "",
                new string[] { "Location, FirstPlayer, SecondPlayer"}))
            {
                chessGameToUpdate.FirstPlayer = db.People.Find(firstPlayerID);
                chessGameToUpdate.SecondPlayer = db.People.Find(secondPlayerID);

                if (chessGameToUpdate.UploadedFiles == null)
                {
                    chessGameToUpdate.UploadedFiles = new List<UploadedFile>(); 
                }
                foreach (var file in files)
                {
                    if (file != null && file.ContentLength > 0)
                    {
                        var picture = new UploadedFile
                        {
                            Name = Path.GetFileName(file.FileName),
                            ContentType = file.ContentType
                        };
                        using (var reader = new BinaryReader(file.InputStream))
                        {
                            picture.Content = reader.ReadBytes(file.ContentLength);
                        }
                        chessGameToUpdate.UploadedFiles.Add(picture);
                    }
                }

                db.Entry(chessGameToUpdate).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(chessGameToUpdate);
        }

        // GET: ChessGame/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            ChessGame chessGame = db.ChessGames
                .Include(cg => cg.UploadedFiles)
                .SingleOrDefault(cg => cg.IDChessGame == id);
            if (chessGame == null)
            {
                return HttpNotFound();
            }
            return View(chessGame);
        }

        // POST: ChessGame/Delete/5
        [HttpPost]
        [ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id)
        {
            db.UploadedFiles.RemoveRange(db.UploadedFiles.Where(file => file.ChessGameIDChessGame == id));
            db.ChessGames.Remove(db.ChessGames.Find(id));
            db.SaveChanges();
            return RedirectToAction("Index");
        }
    }
}
