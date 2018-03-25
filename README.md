# Ethereum Decentralized application
This document provides you the guidance on how to create a decentralized application and test on ethereum blockchain

##### Tools and Frameworks
We are using followinng tools and frameworks for this application
* [truffle] - as development tool.
* [Ganache] - as ethereum development test network.
* [Metamask] - as Web3 Api injector
* [angular-cli] - as framework for web client application.

The steps are
- Download and Install Ganache
- Install truffle
- Create truffle project structure
- Create smart contract
- Compile and deploy the smart contract
- Create angular 5 application
- Interact with blockchain with smart contract method call
##### 1. Install Ganache
Download and install ganache based on your OS. ganache comes guid and cli mode. lets use gui one now
http://truffleframework.com/ganache/
If you open ganache after install, you can see 10 fake ethereum accounts with balance of 100 ether  for each  account. 
##### 2. truffle Project
install truffle and Create truffle project
Create a directory 'ethereumdapp' and create truffle project. use 'truffle init' command
```sh
D:\blockchain\ethereum>npm install -g truffle
D:\blockchain\ethereum>mkdir ethereumdapp
D:\blockchain\ethereum>cd ethereumdapp
D:\blockchain\ethereum\ethereumdapp>truffle init
Downloading...
Unpacking...
Setting up...
Unbox successful. Sweet!
Commands:
  Compile:        truffle compile
  Migrate:        truffle migrate
  Test contracts: truffle test
D:\blockchain\ethereum\ethereumdapp>dir
03/24/2018  05:15 PM    <DIR>          .
03/24/2018  05:15 PM    <DIR>          ..
03/24/2018  05:15 PM    <DIR>          contracts
03/24/2018  05:15 PM    <DIR>          migrations
03/24/2018  05:15 PM    <DIR>          test
03/24/2018  05:15 PM               135 truffle-config.js
03/24/2018  05:15 PM               135 truffle.js
               2 File(s)            270 bytes
               5 Dir(s)  222,028,505,088 bytes free
```
##### 3. Create simple smart contract
Now we will create smart contract file. we use solidity as smart contract programminng language version 0.4.19.
The purpose of this contract is to initiate a state variable called 'name' in the blockchain and manipulating that value of that variable by invoking our smart contract method from a dapp. user changes the name variable value and show the change on the page.
contract name is 'NameChange'
View name method is 'showName()
Change name method is changename(string)
Let's create 'NameChange.sol' file  under 'contracts' folder in our project folder(ethereumdapp).  add this   content to the NameChange.sol
```sh
pragma solidity ^0.4.19;

contract NameChange{
	string name;
	function NameChange(string initialname) public {
		name = initialname;
	}
	function showName() public constant returns(string) {
		return name;
	}	
	function changename(string newname)public { 
		name = newname;
    }
}
```
##### 4. Compile the contract
Use 'truffle compile' the contract
```sh
D:\blockchain\ethereum\ethereumdapp>truffle compile
Compiling .\contracts\Migrations.sol...
Compiling .\contracts\NameChange.sol...
Writing artifacts to .\build\contracts
```
It creates a NameChange.json into the /build folder
this files contains the ABI details for the contract, meaning that Application Binary Interface. The Application Binary Interface (ABI) is a data encoding scheme used in Ethereum for working with smart contract. this can be used in later stage of this process.
##### 5. Deploy the contract
Till now, we have created smart contract and compiled. Now the time for deploy the contract to blockchain which is the ganache, the test blockchain.
For that, we need to configure this project with the blockchain address and port number which is available in ganache settings. We can provide this information truffle.js or truffle-config.js in the project folder.
```sh
module.exports = {
  networks: {
    development: {
      host: '127.0.0.1',
      port: 7545,
      network_id: '*' // Match any network id
    }
  }};
```
The above config tells this deploy command to deploy contract ganache. to deploy use truffle migrate command
For migrate / deploy the contract, we need tell how to create instance for contract and send initial paramters if any required to the contract constructor. for that, we need to create 2_deploy_namechange.js in migrations folder in the project
```sh
var NameChange = artifacts.require("./NameChange.sol");
module.exports = function(deployer) {
  deployer.deploy(NameChange,"initial name from chain");
};
```
Every thing is ready to deploy the contract.
```sh
D:\blockchain\ethereum\ethereumdapp> truffle migrate
Using network 'development'.
Running migration: 1_initial_migration.js
  Replacing Migrations...
  ... 0xd0b495e94047c454c62eaa31533491d559de11c84914b5d4a9ce0f7b5703ef57
  Migrations: 0x8cdaf0cd259887258bc13a92c0a6da92698644c0
Saving successful migration to network...
  ... 0xd7bc86d31bee32fa3988f1c1eabce403a1b5d570340a3a9cdba53a472ee8c956
Saving artifacts...
Running migration: 2_deploy_namechange.js
  Replacing NameChange...
  ... 0x4dcf9df45f91b76d204eb86f3e839d9257c7b15008fc5efb6b14abbe0bbdfdf2
  NameChange: 0x345ca3e014aaf5dca488057592ee47305d9b3e10
Saving successful migration to network...
  ... 0xf36163615f41ef7ed8f4a8f192149a0bf633fe1a2398ce001bf44c43dc7bdda0
Saving artifacts...
```
At this stage contract is deployed to the ganache and generated a contract address.

This can confirmed in ganache trasaction list

##### 6.Dapp
This is angular 5 app that we provide user interface to the user to interact with blockchain through this app. we use angular-cli commands to create and run the app
Change directory back a level and execute 'ng new ethereumdapp'
```sh
D:\blockchain\ethereum\ethereumdapp>cd..
D:\blockchain\ethereum>ng new ethereumdapp
```
Let's add UI for viewing the blockchain state variable value on the page. a provision for change the value.
add following code src\app\app.component.html
```sh
<section class="hero is-medium is-info is-bold">
  <div class="hero-body">
    <div class="container">
      <h1 class="title is-1">
        Name change dapp
      </h1>
      <h2 class="title">
        Your Name is: <span class="is-medium has-underline">{{name}}</span>
      </h2>
    </div>
  </div>
</section>
<br>
<div class="container">
  <h1 class="title">Change Name</h1>
  <h1 class="title is-4 is-info help">{{status}}</h1>

  <form #nameForm="ngForm">
    <div class="field">
      <label class="label">New Name</label>
      <p class="control">
        <input
          [(ngModel)]="NewName"
          class="input"
          type="text"
          placeholder="New Name"
          name="NewName"
          required
          #nameChangeModel="ngModel">
      </p>
      <div *ngIf="nameChangeModel.errors && (nameChangeModel.dirty || nameChangeModel.touched)"
           class="help is-danger">
          <p [hidden]="!nameChangeModel.errors.required">
            This field is required
          </p>
      </div>
    </div>
    
    <div class="field is-grouped">
      <p class="control">
        <button
          [disabled]="!nameForm.valid"
          (click)="changeName()"
          class="button is-primary">
          Send
        </button>
      </p>
    </div>
  </form>
</div>
```
UI component / controller code in src\app\app.component.ts 
```sh
import { Component, HostListener, NgZone } from '@angular/core';
const Web3 = require('web3');
const contract = require('truffle-contract');
const nameChangeArtifacts = require('../../build/contracts/NameChange.json');

declare var window: any;

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  name = 'Initial name from component';
  NewName : string;
  nameChange = contract(nameChangeArtifacts);

  account: any;
  accounts: any;
  web3: any;
  status: string;
  constructor(private _ngZone: NgZone) {

  }
  @HostListener('window:load')
  windowLoaded() {
    this.checkAndInstantiateWeb3();
    this.onReady();
  }

  checkAndInstantiateWeb3 = () => {
    // Checking if Web3 has been injected by the browser (Mist/MetaMask)
    if (typeof window.web3 !== 'undefined') {
      console.warn(
        'Using web3 detected from external source. If you find that your accounts don\'t appear or you have 0 MetaCoin, ensure you\'ve configured that source properly. If using MetaMask, see the following link. Feel free to delete this warning. :) http://truffleframework.com/tutorials/truffle-and-metamask'
      );
      // Use Mist/MetaMask's provider
      this.web3 = new Web3(window.web3.currentProvider);
    } else {
      console.warn(
        'No web3 detected. Falling back to http://127.0.0.1:8545. You should remove this fallback when you deploy live, as it\'s inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask'
      );
      // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
      this.web3 = new Web3(
        new Web3.providers.HttpProvider('http://127.0.0.1:7545')
      );
    }
  };

  onReady = () => {
    // Bootstrap the MetaCoin abstraction for Use.
    this.nameChange.setProvider(this.web3.currentProvider);

    // Get the initial account balance so it can be displayed.
    this.web3.eth.getAccounts((err, accs) => {
      if (err != null) {
        alert('There was an error fetching your accounts.');
        return;
      }

      if (accs.length === 0) {
        alert(
          'Couldn\'t get any accounts! Make sure your Ethereum client is configured correctly.' 
        );
        return;
      }
      console.log(accs);
      this.accounts = accs;
      this.account = this.accounts[0];

      // This is run from window:load and ZoneJS is not aware of it we
      // need to use _ngZone.run() so that the UI updates on promise resolution
      this._ngZone.run(() =>
        this.refreshName()
      );
    });
  };

  refreshName = () => {
    let nc;
    this.nameChange
      .deployed()
      .then(instance => {
        nc = instance;
        return nc.showName.call({
          from: this.account
        });
      })
      .then(value => {
        this.name = value;
      })
      .catch(e => {
        console.log(e);
        this.setStatus('Error getting name; see log.');
      });
  };

  changeName = () => {
    const nawname = this.NewName;
    let nc;

    this.setStatus('Initiating transaction... (please wait)');

    this.nameChange
      .deployed()
      .then(instance => {
        nc = instance;
        return nc.changename(nawname,{from: this.account})
      })
      .then(() => {
        this.setStatus('Transaction complete!');
        this.refreshName();
      })
      .catch(e => {
        console.log(e);
        this.setStatus('Error changing name; see log.');
      });
  };
  setStatus = message => {
    this.status = message;
  };
}
```

Now ready to the serve the app
Change directory to the ethereumdapp
```sh
D:\blockchain\ethereum>cd ethereumdapp
D:\blockchain\ethereum\ethereumdapp>ng serve -o
```
It opens the browser with localhost:4200 and shows our page.

enter the name in new name textbox and hit submit
**Free Software, Hell Yeah!**

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

[truffle]: <http://truffleframework.com/>
[angular-cli]: <https://cli.angular.io/>
[ganache]: <http://truffleframework.com/ganache/>
   [MetaMask]: <https://chrome.google.com/webstore/detail/metamask/nkbihfbeogaeaoehlefnkodbefgpgknn>
