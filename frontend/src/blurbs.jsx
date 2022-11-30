import React from "react";
import ReactDOM from "react-dom/client";
const bl_root = ReactDOM.createRoot(document.getElementById('blurb-list-root'));
//const search_root = ReactDOM.createRoot(document.getElementById('search-root'));

class Blurb extends React.Component {
  render() {
    return <div className="blurb" id={this.props.id} >
             <p> {this.props.date} </p>
             <button onTouchStart={this.props.onDelete} onClick={this.props.onDelete} className="delete-button">🗑️</button>
             <p> {this.props.content} </p>
           </div>;
  }
}

class App extends React.Component {
  constructor(props) {
    super(props);

    this.handleNewBlurb = this.handleNewBlurb.bind(this);
    this.handleContentChange = this.handleContentChange.bind(this);
    this.handleDeleteBlurb = this.handleDeleteBlurb.bind(this);

    this.state = {
      newContent: "LOADING",
      blurbs: [<Blurb key="1" content="LOADING..." />]
    }
    fetch('/blurbs', {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json;charset=utf-8'
      },
    }).then(res => res.json()).then((json) => {
      const blurbs = json.blurbs.map( blurb => {
        return <li key={blurb.blurb_id}> 
                 <Blurb id={"blurb_id-" + blurb.blurb_id} date={blurb.date} content={blurb.content} onDelete={this.handleDeleteBlurb}/>
               </li>;
      });
      this.setState({
        newContent: "",
        blurbs: blurbs,
      });
    });

  }

  handleDeleteBlurb(e) {
    console.log(e);
    console.log(e.target.parentElement.attributes.id);
    // formatted like 'blurb_id-123'
    const [ ,blurb_id] = e.target.parentElement.attributes.id.nodeValue.split('-');
    console.log(blurb_id);
    fetch('/blurb/' + blurb_id, {
      method: 'DELETE',
      headers: {
        'Content-Type': 'application/json;charset=utf-8'
      },
    });
    this.setState({
      blurbs: this.state.blurbs.filter((b) => b.key !== blurb_id),
    });
  }

  handleContentChange(e) {
    this.setState({newContent: e.target.value});
  }

  handleNewBlurb(e) {
    //TODO: implement
    fetch('/blurb', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json;charset=utf-8'
      },
      body: JSON.stringify({ blurb_content: this.state.newContent })
    }).then(res => res.json()).then((json) => {
      let blurb = <li key={json.blurb_id} >
                    <Blurb date={json.date} content={this.state.newContent} onDelete={this.handleDeleteBlurb}/>
                  </li>;
      this.setState({ 
        newContent: "",
        blurbs: [blurb].concat(this.state.blurbs),
      });
    });
    
    e.preventDefault();
  }

  render() {
    return <div className="app">
      <form onSubmit={this.handleNewBlurb}>
        <input name="blurb_content" type="text" value={this.state.newContent} onChange={this.handleContentChange} autoFocus autoComplete="off"/>
        <input type="hidden" name="username" value="TODO_USERNAME"/>
        <input type="submit" value="write new blurb"/>
      </form>

        <ul className="blurbList skinny"> { this.state.blurbs } </ul>
    </div>
  }
}

bl_root.render(<App/>);

