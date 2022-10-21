pragma solidity 0.8.6;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

contract FootballBattleContract is ERC721 {

    struct FootballClubs{
        string nome;
        uint ano;
        uint qnt_titulos;
        uint level;
    }

    
    FootballClubs[] public footballClubs; //Array q guarda os dados do Clubs Cards
    address public Owner;//variavel Owner guarda o hash da conta /9dono do jogo)

    //NOME DO TOKEN e o Simbolo
    constructor() ERC721("Football Token", "FTB"){
        Owner = msg.sender; //Guarda o hash da conta do usuário q fez o deploy
    }

    modifier onlyOwnerOf(uint _attackingClub){
        require(ownerOf(_attackingClub) == msg.sender, "Somente o dono");
        _;
    }

    function creatNewFootbalClub(string  memory _nome, uint _ano, uint _qnt_titulos, address _to) public{
        require(msg.sender == Owner, "Somente o dono do jogo pode criar um novo Club!");
        uint id = footballClubs.length;
        footballClubs.push(FootballClubs(_nome,_ano, _qnt_titulos, 1));
        _safeMint(_to, id);
    }

    function battle(uint _attackingFootballClub, uint _defendingFootballClub) public onlyOwnerOf(_attackingFootballClub){
        FootballClubs storage attacker = footballClubs[_attackingFootballClub];
        FootballClubs storage defender = footballClubs[_defendingFootballClub];

        if(attacker.level >= defender.level) {
            attacker.level += 2;
            defender.level += 1;
        }
        else{
            attacker.level += 1;
            defender.level += 2;
        }
    }
}